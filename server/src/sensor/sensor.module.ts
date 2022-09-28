import { CreateSensorService } from './services';
import { Module } from '@nestjs/common';
import { MqttModule } from '../mqtt';
import { OrmModule } from '../orm/orm.module';
import { SensorController } from './controllers';

@Module({
  imports: [MqttModule, OrmModule],
  providers: [CreateSensorService],
  controllers: [SensorController],
  exports: [CreateSensorService],
})
export class SensorModule {}
