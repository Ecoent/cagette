import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Group } from "./Group";

@Index("LemonWayConfig_groupId", ["groupId"], {})
@Entity("LemonWayConfig", { schema: "db" })
export class LemonWayConfig {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "wallet", length: 128 })
  wallet: string;

  @Column("varchar", { name: "email", length: 128 })
  email: string;

  @Column("varchar", { name: "password", length: 128 })
  password: string;

  @Column("int", { name: "groupId" })
  groupId: number;

  @ManyToOne(
    () => Group,
    group => group.lemonWayConfigs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;
}
