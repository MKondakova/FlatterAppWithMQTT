  import { Client } from '../client.entity';
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { PublishMessageService } from '../../mqtt';
import { Sensor } from '@/sensor/sensor.entity';
import { ClientSubscribeDto } from '../dto/client-subscribe.dto';

@Injectable()
export class SubscribeClientService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
    @InjectRepository(Sensor)
    private sensorRepository: Repository<Sensor>,
  ) { }

  public async execute(data: ClientSubscribeDto) {
    const client = await this.clientRepository.findOne({
      where: {
        username: data.username
      },
      relations: ['sensors']
    });
    const sensor = await this.sensorRepository.findOne({ guid: data.sensorGuid });

    if (!client || !sensor) {
      this.publishMessageService.execute({
        topic: `client/subscribe/${data.username}`,
        payload: 'failed',
      });
      throw new Error('Client or sensor not found')
    }
    if (!client.sensors?.find(s => s.guid === sensor.guid)) {
      await this.clientRepository.save({
        ...client,
        sensors: [...(client.sensors ?? []), sensor]
      });
    }
    this.publishMessageService.execute({
      topic: `client/subscribe/${data.username}`,
      payload: 'success',
    });
  }
}
