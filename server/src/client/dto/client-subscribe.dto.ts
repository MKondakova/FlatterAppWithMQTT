import { IsString, IsUUID, MaxLength, MinLength } from 'class-validator';

export class ClientSubscribeDto {
  @IsString()
  @MaxLength(8)
  @MinLength(2)
  public readonly username: string;

  @IsUUID()
  public readonly sensorGuid: string;
}
