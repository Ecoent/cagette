import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { MultiDistrib } from "./MultiDistrib";

@Index("MangopayGroupPayOut_multiDistribId", ["multiDistribId"], {})
@Entity("MangopayGroupPayOut", { schema: "db" })
export class MangopayGroupPayOut {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("int", { name: "payOutId" })
  payOutId: number;

  @Column("mediumblob", { name: "cachedDatas", nullable: true })
  cachedDatas: Buffer | null;

  @Column("int", { name: "multiDistribId" })
  multiDistribId: number;

  @ManyToOne(
    () => MultiDistrib,
    multiDistrib => multiDistrib.mangopayGroupPayOuts,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "multiDistribId", referencedColumnName: "id" }])
  multiDistrib: MultiDistrib;
}
