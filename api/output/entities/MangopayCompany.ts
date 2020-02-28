import {
  Column,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { CagettePro } from "./CagettePro";

@Entity("MangopayCompany", { schema: "db" })
export class MangopayCompany {
  @Column("varchar", { name: "mangopayUserId", length: 256 })
  mangopayUserId: string;

  @PrimaryGeneratedColumn({ type: "int", name: "companyId" })
  companyId: number;

  @OneToOne(
    () => CagettePro,
    cagettePro => cagettePro.mangopayCompany,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;
}
