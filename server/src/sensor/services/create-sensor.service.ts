import { Injectable } from '@nestjs/common';
import { PublishMessageService } from 'src/mqtt/service/publish-message.service';
import { Sensor } from '../sensor.entity';
import { SensorCreateDto } from '../dto';
import { StorageHandlerService } from 'src/storage/services';

@Injectable()
export class CreateSensorService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    private readonly storageHandlerService: StorageHandlerService,
  ) {}

  public execute(data: SensorCreateDto) {
    this.storageHandlerService.createSensor(new Sensor(data));
    this.publishMessageService.execute({
      topic: `sensor/create/${data.guid}`,
      payload: data.guid,
    });
  }
}
