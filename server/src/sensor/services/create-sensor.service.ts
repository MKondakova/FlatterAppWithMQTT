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
    private sensorRepository: Repository<Sensor>,
  ) {}

  public async execute(data: SensorCreateDto) {
    const existingSensor = await this.sensorRepository.findOne({
      guid: data.guid,
    });
    if (existingSensor) {
      this.publishMessageService.execute({
        topic: `sensor/create/${data.guid}`,
        payload: 'success',
      });
      throw new Error('Sensor exists');
    }
    await this.sensorRepository.save(data);
    this.publishMessageService.execute({
      topic: `sensor/create/${data.guid}`,
      payload: 'success',
    });
  }
}
