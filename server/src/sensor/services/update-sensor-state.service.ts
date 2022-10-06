import { Injectable } from '@nestjs/common';
import { Sensor } from '../sensor.entity';
import { SensorUpdateDto } from '../dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PublishMessageService } from '../../mqtt';

@Injectable()
export class UpdateSensorStateService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    @InjectRepository(Sensor)
    private sensorRepository: Repository<Sensor>,
  ) {}

  public async execute(data: SensorUpdateDto) {
    const sensor = await this.sensorRepository.findOne({
         where: {guid: data.guid},
         relations: ['clients']
        });
   
    await this.sensorRepository.save({
        ...sensor,
        state: data.state
    });

     sensor.clients.forEach(c => this.publishMessageService.execute({topic: `client/${c.username}`, payload: JSON.stringify(data)}))
     this.publishMessageService.execute({topic: `sensor/${sensor.guid}`, payload: JSON.stringify(data)})
     
  }
}
