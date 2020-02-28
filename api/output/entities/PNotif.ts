import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { CagettePro } from "./CagettePro";
import { Group } from "./Group";
import { User } from "./User";

@Index("PNotif_groupId", ["groupId"], {})
@Index("PNotif_companyId", ["companyId"], {})
@Index("PNotif_userId", ["userId"], {})
@Entity("PNotif", { schema: "db" })
export class PNotif {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("tinyint", { name: "type", unsigned: true })
  type: number;

  @Column("tinytext", { name: "title" })
  title: string;

  @Column("mediumblob", { name: "content" })
  content: Buffer;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("int", { name: "companyId" })
  companyId: number;

  @Column("int", { name: "groupId", nullable: true })
  groupId: number | null;

  @Column("int", { name: "userId", nullable: true })
  userId: number | null;

  @ManyToOne(
    () => CagettePro,
    cagettePro => cagettePro.pNotifs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;

  @ManyToOne(
    () => Group,
    group => group.pNotifs,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => User,
    user => user.pNotifs,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
