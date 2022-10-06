import { Client } from '../client.entity';
import { ClientCreateDto } from '../dto';
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { PublishMessageService } from '../../mqtt';

@Injectable()
export class LoginClientService {
  public constructor(
    private readonly publishMessageService: PublishMessageService,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  public async execute(data: ClientCreateDto) {
    const existingUser = await this.clientRepository.findOne(data);
    if (!existingUser) {
      this.publishMessageService.execute({
        topic: `client/login/${data.username}`,
        payload: 'failed',
      });
      throw new Error('Password incorrect or no client with such credentials');
    }
    this.publishMessageService.execute({
      topic: `client/login/${data.username}`,
      payload: 'success',
    });
  }
}
