import { CreateSensorService } from './services';
import { Module } from '@nestjs/common';
import { MqttModule } from 'src/mqtt';
import { SensorController } from './controllers';
import { StorageModule } from 'src/storage';

@Module({
  imports: [MqttModule, StorageModule],
  providers: [CreateSensorService],
  controllers: [SensorController],
  exports: [CreateSensorService],
})
export class SensorModule {}
