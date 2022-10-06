import { CreateClientService, LoginClientService } from './services';

import { Client } from './client.entity';
import { ClientController } from './controllers';
import { Module } from '@nestjs/common';
import { MqttModule } from '../mqtt';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [MqttModule, TypeOrmModule.forFeature([Client])],
  providers: [CreateClientService, LoginClientService],
  controllers: [ClientController],
})
export class ClientModule {}
