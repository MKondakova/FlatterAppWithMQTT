import { Client } from '../client.entity';
import { ClientCreateDto } from '../dto';
import { Injectable } from '@nestjs/common';
import { PublishMessageService } from 'src/mqtt';
import { StorageHandlerService } from 'src/storage';

@Injectable()
export class CreateClientService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    private readonly storageHandlerService: StorageHandlerService,
  ) {}

  public execute(data: ClientCreateDto) {
    this.storageHandlerService.createClient(new Client(data));
    this.publishMessageService.execute({
      topic: `client/create/${data.username}`,
      payload: 'success',
    });
  }
}
