  import { Client } from '../client.entity';
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { PublishMessageService } from '../../mqtt';
import { SubscriptionsFilterDto } from '../dto';

@Injectable()
export class GetAllSubscriptionsService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) { }

  public async execute(data: SubscriptionsFilterDto) {
    const client = await this.clientRepository.findOne({
      where: {
        username: data.username
      },
      relations: ['sensors']
    });
  

    if (!client) {
      this.publishMessageService.execute({
        topic: `client/subscriptions/${data.username}`,
        payload: 'failed',
      });
      throw new Error('Client not found')
    }

    this.publishMessageService.execute({
      topic: `client/subscriptions/${data.username}`,
      payload: JSON.stringify(client.sensors.map(s => ({title: 'title', sensor: s}))),
    });
  }
}
