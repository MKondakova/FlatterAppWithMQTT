import { ClientController } from './controllers';
import { CreateClientService } from './services';
import { Module } from '@nestjs/common';
import { MqttModule } from 'src/mqtt';
import { StorageModule } from 'src/storage';

@Module({
  imports: [MqttModule, StorageModule],
  providers: [CreateClientService],
  controllers: [ClientController],
})
export class ClientModule {}
