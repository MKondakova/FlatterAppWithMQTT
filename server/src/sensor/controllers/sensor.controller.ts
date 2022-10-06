import { CreateSensorService, UpdateSensorStateService } from '../services';
import { SensorCreateDto, SensorUpdateDto } from '../dto';

import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

@Controller('')
export class SensorController {
  public constructor(
    private readonly createSensorService: CreateSensorService,
    private readonly updateSensorService: UpdateSensorStateService,
  ) {}
  @MessagePattern('sensor/create')
  async createSensor(data: SensorCreateDto) {
    await this.createSensorService.execute(data);
  }

  @MessagePattern('sensor/update')
  async updateSensor(data: SensorUpdateDto) {
    await this.updateSensorService.execute(data);
  }
}
