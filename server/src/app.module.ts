import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ClientModule } from './client';
import { Module } from '@nestjs/common';
import { MqttModule } from './mqtt';
import { SensorModule } from './sensor/sensor.module';

@Module({
  imports: [MqttModule, ClientModule, SensorModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
