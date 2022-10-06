import { IsString, IsUUID } from 'class-validator';

export class SensorCreateDto {
  @IsString()
  @IsUUID()
  public readonly guid: string;
}
