export class Sensor {
  public title: string;
  public guid: string;

  public constructor(v: Partial<Sensor>) {
    Object.assign(this, v);
  }
}
