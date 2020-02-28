import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { User } from "./User";

@Index("Error_uid", ["uid"], {})
@Entity("Error", { schema: "db" })
export class Error {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("varchar", { name: "ip", nullable: true, length: 15 })
  ip: string | null;

  @Column("int", { name: "uid", nullable: true })
  uid: number | null;

  @Column("tinytext", { name: "url", nullable: true })
  url: string | null;

  @Column("mediumtext", { name: "error" })
  error: string;

  @Column("varchar", { name: "userAgent", nullable: true, length: 256 })
  userAgent: string | null;

  @ManyToOne(
    () => User,
    user => user.errors,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "uid", referencedColumnName: "id" }])
  u: User;
}
