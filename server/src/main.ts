import * as aedes from 'aedes';

import { MicroserviceOptions, Transport } from '@nestjs/microservices';

import { AppModule } from './app.module';
import { NestFactory } from '@nestjs/core';
import { ServerRunnerService } from './mqtt';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.createMicroservice<MicroserviceOptions>(
    AppModule,
    {
      transport: Transport.MQTT,
      options: {
        url: 'mqtt://localhost',
        port: 1883,
      },
    },
  );
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  app.listen();
  const aedesServer = aedes.Server();
  ServerRunnerService.AedesServer = aedesServer;
  const runBrokerService = app.get<ServerRunnerService>(ServerRunnerService);
  runBrokerService.execute();
}
bootstrap();
