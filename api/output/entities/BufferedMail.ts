import { Column, Entity, Index, PrimaryGeneratedColumn } from "typeorm";

@Index("BufferedMail_remoteId_sdate_cdate", ["remoteId", "sdate", "cdate"], {})
@Entity("BufferedMail", { schema: "db" })
export class BufferedMail {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "title", length: 256 })
  title: string;

  @Column("mediumtext", { name: "htmlBody", nullable: true })
  htmlBody: string | null;

  @Column("mediumtext", { name: "textBody", nullable: true })
  textBody: string | null;

  @Column("mediumblob", { name: "headers" })
  headers: Buffer;

  @Column("mediumblob", { name: "sender" })
  sender: Buffer;

  @Column("mediumblob", { name: "recipients" })
  recipients: Buffer;

  @Column("varchar", { name: "mailerType", length: 32 })
  mailerType: string;

  @Column("int", { name: "tries" })
  tries: number;

  @Column("datetime", { name: "cdate" })
  cdate: Date;

  @Column("datetime", { name: "sdate", nullable: true })
  sdate: Date | null;

  @Column("mediumtext", { name: "rawStatus", nullable: true })
  rawStatus: string | null;

  @Column("mediumblob", { name: "status", nullable: true })
  status: Buffer | null;

  @Column("mediumblob", { name: "data", nullable: true })
  data: Buffer | null;

  @Column("int", { name: "remoteId", nullable: true })
  remoteId: number | null;
}
