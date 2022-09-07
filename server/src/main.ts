import * as aedes from 'aedes';
import * as net from 'net';

import { AppModule } from './app.module';
import { NestFactory } from '@nestjs/core';

const a = aedes.Server()
const server = net.createServer(a.handle)
const port = 1883

server.listen(port, function () {
  console.log('server started and listening on port ', port)
})

a.on('publish', (packet, client) => {
  console.log(packet, client);
  
});

server.on('connection', (connData: any) => {
  console.log('new connection!');
  console.log(connData);
  
  
})

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
