import { Controller } from '@nestjs/common';
import { CreateSensorService } from '../services';
import { MessagePattern } from '@nestjs/microservices';
import { SensorCreateDto } from '../dto';

@Controller('')
export class SensorController {
  public constructor(
    private readonly createSensorService: CreateSensorService,
  ) {}
  @MessagePattern('sensor/create')
  handleSignup(data: SensorCreateDto) {
    this.createSensorService.execute(data);
  }
}
