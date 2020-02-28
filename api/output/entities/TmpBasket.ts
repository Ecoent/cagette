import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { MultiDistrib } from "./MultiDistrib";
import { User } from "./User";

@Index("TmpBasket_ref", ["ref"], {})
@Index("TmpBasket_multiDistribId", ["multiDistribId"], {})
@Index("TmpBasket_userId", ["userId"], {})
@Entity("TmpBasket", { schema: "db" })
export class TmpBasket {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "ref", nullable: true, length: 256 })
  ref: string | null;

  @Column("datetime", { name: "cdate" })
  cdate: Date;

  @Column("mediumblob", { name: "data" })
  data: Buffer;

  @Column("int", { name: "userId", nullable: true })
  userId: number | null;

  @Column("int", { name: "multiDistribId" })
  multiDistribId: number;

  @ManyToOne(
    () => MultiDistrib,
    multiDistrib => multiDistrib.tmpBaskets,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "multiDistribId", referencedColumnName: "id" }])
  multiDistrib: MultiDistrib;

  @ManyToOne(
    () => User,
    user => user.tmpBaskets,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
