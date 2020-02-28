import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity("RemoteCatalog", { schema: "db" })
export class RemoteCatalog {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("int", { name: "remoteCatalogId" })
  remoteCatalogId: number;

  @Column("tinyint", { name: "needSync", width: 1 })
  needSync: boolean;

  @Column("mediumtext", { name: "disabledProducts", nullable: true })
  disabledProducts: string | null;
}
