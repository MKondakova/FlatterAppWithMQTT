import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ClientModule } from './client';
import { Module } from '@nestjs/common';
import { MqttModule } from './mqtt';
import { OrmModule } from './orm/orm.module';
import { SensorModule } from './sensor/sensor.module';

@Module({
  imports: [ClientModule, MqttModule, SensorModule, OrmModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
