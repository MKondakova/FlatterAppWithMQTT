import { Injectable } from '@nestjs/common';
import { Sensor } from '../sensor.entity';
import { SensorCreateDto } from '../dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PublishMessageService } from '../../mqtt';

@Injectable()
export class CreateSensorService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    @InjectRepository(Sensor)
    private clientRepository: Repository<Sensor>,
  ) {}

  public async execute(data: SensorCreateDto) {
    await this.clientRepository.save(data);
    this.publishMessageService.execute({
      topic: `sensor/create/${data.guid}`,
      payload: data.guid,
    });
  }
}
