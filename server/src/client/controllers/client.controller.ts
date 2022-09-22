import { ClientCreateDto } from '../dto';
import { Controller } from '@nestjs/common';
import { CreateClientService } from '../services';
import { MessagePattern } from '@nestjs/microservices';

@Controller('')
export class ClientController {
  public constructor(
    private readonly createClientService: CreateClientService,
  ) {}
  @MessagePattern('client/create')
  handleSignup(data: ClientCreateDto) {
    this.createClientService.execute(data);
  }
}
