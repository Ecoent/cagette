import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity("Hosting", { schema: "db" })
export class Hosting {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("datetime", { name: "cdate", nullable: true })
  cdate: Date | null;

  @Column("tinyint", { name: "visible", width: 1 })
  visible: boolean;

  @Column("int", { name: "membersNum" })
  membersNum: number;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("int", { name: "cproContractNum" })
  cproContractNum: number;

  @Column("int", { name: "contractNum" })
  contractNum: number;
}
