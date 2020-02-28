import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { CagettePro } from "./CagettePro";
import { User } from "./User";

@Index("PMessage_companyId", ["companyId"], {})
@Index("PMessage_senderId", ["senderId"], {})
@Entity("PMessage", { schema: "db" })
export class PMessage {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "recipientListId", length: 12 })
  recipientListId: string;

  @Column("varchar", { name: "title", length: 128 })
  title: string;

  @Column("mediumtext", { name: "body" })
  body: string;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("int", { name: "senderId" })
  senderId: number;

  @Column("int", { name: "companyId" })
  companyId: number;

  @ManyToOne(
    () => CagettePro,
    cagettePro => cagettePro.pMessages,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;

  @ManyToOne(
    () => User,
    user => user.pMessages,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "senderId", referencedColumnName: "id" }])
  sender: User;
}
