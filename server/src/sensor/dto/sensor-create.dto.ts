import { IsString, IsUUID, MaxLength, MinLength } from 'class-validator';

export class SensorCreateDto {
  @IsString()
  @MaxLength(8)
  @MinLength(2)
  public readonly title: string;

  @IsString()
  @IsUUID()
  public readonly guid: string;
}
