import { IsString, IsUUID, MaxLength, MinLength } from 'class-validator';

export class SensorCreateDto {
  @IsString()
  @IsUUID()
  public readonly guid: string;
}
