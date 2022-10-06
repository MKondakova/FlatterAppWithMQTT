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
         relations: ['subscriptions', 'subscriptions.client']
        });
   
    await this.sensorRepository.save({
        ...sensor,
        state: data.state
    });

    console.log(sensor);
    

     sensor.subscriptions.forEach(s => this.publishMessageService.execute({topic: `client/${s.client.username}`, payload: JSON.stringify(data)}))
     this.publishMessageService.execute({topic: `sensor/${sensor.guid}`, payload: JSON.stringify(data)})
     
  }
}
