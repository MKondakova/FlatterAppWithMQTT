import { Client } from '../client.entity';
import { ClientCreateDto } from '../dto';
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { PublishMessageService } from '../../mqtt';

@Injectable()
export class CreateClientService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  public async execute(data: ClientCreateDto) {
    await this.clientRepository.save(data);
    this.publishMessageService.execute({
      topic: `client/create/${data.username}`,
      payload: 'success',
    });
  }
}
