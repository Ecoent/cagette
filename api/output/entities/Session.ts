import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { User } from "./User";

@Index("Session_uid", ["uid"], {})
@Entity("Session", { schema: "db" })
export class Session {
  @Column("varchar", { primary: true, name: "sid", length: 32 })
  sid: string;

  @Column("int", { name: "uid", nullable: true })
  uid: number | null;

  @Column("datetime", { name: "lastTime" })
  lastTime: Date;

  @Column("datetime", { name: "createTime" })
  createTime: Date;

  @Column("mediumblob", { name: "sdata" })
  sdata: Buffer;

  @Column("varchar", { name: "lang", length: 2 })
  lang: string;

  @Column("mediumblob", { name: "messages" })
  messages: Buffer;

  @Column("varchar", { name: "ip", length: 15 })
  ip: string;

  @ManyToOne(
    () => User,
    user => user.sessions,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "uid", referencedColumnName: "id" }])
  u: User;
}
