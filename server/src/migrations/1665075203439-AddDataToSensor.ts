import {MigrationInterface, QueryRunner} from "typeorm";

export class AddDataToSensor1665075203439 implements MigrationInterface {
    name = 'AddDataToSensor1665075203439'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "sensor" ADD "data" text NOT NULL DEFAULT ''`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "sensor" DROP COLUMN "data"`);
    }
}
