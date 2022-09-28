import { MigrationInterface, QueryRunner } from 'typeorm';

export class Inital1664388303146 implements MigrationInterface {
  name = 'Inital1664388303146';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `CREATE TABLE "client" ("id" SERIAL NOT NULL, "username" text NOT NULL, "password" text NOT NULL, CONSTRAINT "PK_96da49381769303a6515a8785c7" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TABLE "sensor" ("id" SERIAL NOT NULL, "guid" uuid NOT NULL, "title" text NOT NULL, CONSTRAINT "PK_ccc38b9aa8b3e198b6503d5eee9" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TABLE "client_sensors_sensor" ("clientId" integer NOT NULL, "sensorId" integer NOT NULL, CONSTRAINT "PK_758e80f50c4639bf433e7ef029e" PRIMARY KEY ("clientId", "sensorId"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_911be93f1e6a5d190c20539e0e" ON "client_sensors_sensor" ("clientId") `,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_912bd07083521efb222eec894c" ON "client_sensors_sensor" ("sensorId") `,
    );
    await queryRunner.query(
      `ALTER TABLE "client_sensors_sensor" ADD CONSTRAINT "FK_911be93f1e6a5d190c20539e0e6" FOREIGN KEY ("clientId") REFERENCES "client"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
    await queryRunner.query(
      `ALTER TABLE "client_sensors_sensor" ADD CONSTRAINT "FK_912bd07083521efb222eec894c6" FOREIGN KEY ("sensorId") REFERENCES "sensor"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "client_sensors_sensor" DROP CONSTRAINT "FK_912bd07083521efb222eec894c6"`,
    );
    await queryRunner.query(
      `ALTER TABLE "client_sensors_sensor" DROP CONSTRAINT "FK_911be93f1e6a5d190c20539e0e6"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_912bd07083521efb222eec894c"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_911be93f1e6a5d190c20539e0e"`,
    );
    await queryRunner.query(`DROP TABLE "client_sensors_sensor"`);
    await queryRunner.query(`DROP TABLE "sensor"`);
    await queryRunner.query(`DROP TABLE "client"`);
  }
}
