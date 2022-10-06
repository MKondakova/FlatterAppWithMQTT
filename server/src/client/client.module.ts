import { CreateClientService, GetAllSubscriptionsService, LoginClientService, SubscribeClientService } from './services';

import { Client } from './client.entity';
import { ClientController } from './controllers';
import { Module } from '@nestjs/common';
import { MqttModule } from '../mqtt';
import { Sensor } from '@/sensor/sensor.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [MqttModule, TypeOrmModule.forFeature([Client]), TypeOrmModule.forFeature([Sensor])],
  providers: [CreateClientService, GetAllSubscriptionsService, LoginClientService, SubscribeClientService],
  controllers: [ClientController],
})
export class ClientModule {}
