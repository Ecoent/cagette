import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Group } from "./Group";
import { User } from "./User";

@Index("Message_amapId", ["amapId"], {})
@Index("Message_senderId", ["senderId"], {})
@Entity("Message", { schema: "db" })
export class Message {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "recipientListId", nullable: true, length: 12 })
  recipientListId: string | null;

  @Column("varchar", { name: "title", length: 128 })
  title: string;

  @Column("mediumtext", { name: "body" })
  body: string;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("int", { name: "senderId", nullable: true })
  senderId: number | null;

  @Column("int", { name: "amapId", nullable: true })
  amapId: number | null;

  @Column("mediumblob", { name: "recipients", nullable: true })
  recipients: Buffer | null;

  @ManyToOne(
    () => Group,
    group => group.messages,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "amapId", referencedColumnName: "id" }])
  amap: Group;

  @ManyToOne(
    () => User,
    user => user.messages,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "senderId", referencedColumnName: "id" }])
  sender: User;
}
