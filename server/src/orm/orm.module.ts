import { Client } from '../client/client.entity';
import { Module } from '@nestjs/common';
import { Sensor } from '../sensor/sensor.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import config from '../orm.config';

@Module({
  imports: [
    TypeOrmModule.forRoot(config),
    TypeOrmModule.forFeature([Client, Sensor]),
  ],
  exports: [TypeOrmModule],
})
export class OrmModule {}
