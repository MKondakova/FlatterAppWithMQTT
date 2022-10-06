import { Module } from '@nestjs/common';
import { MqttModule } from '../mqtt';
import { Subscription } from './subscription.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [MqttModule, TypeOrmModule.forFeature([Subscription])],
})
export class ClientModule {}
