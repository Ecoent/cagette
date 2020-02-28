import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Catalog } from "./Catalog";

@Index("WConfig_contract1Id", ["contract1Id"], {})
@Entity("WConfig", { schema: "db" })
export class WConfig {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("int", { name: "contract1Id" })
  contract1Id: number;

  @ManyToOne(
    () => Catalog,
    catalog => catalog.wConfigs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "contract1Id", referencedColumnName: "id" }])
  contract: Catalog;
}
