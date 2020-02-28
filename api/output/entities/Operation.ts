import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Group } from "./Group";
import { User } from "./User";

@Index("Operation_groupId", ["groupId"], {})
@Index("Operation_userId", ["userId"], {})
@Index("Operation_relationId", ["relationId"], {})
@Entity("Operation", { schema: "db" })
export class Operation {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("double", { name: "amount", precision: 22 })
  amount: number;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("tinyint", { name: "type", unsigned: true })
  type: number;

  @Column("mediumblob", { name: "data" })
  data: Buffer;

  @Column("tinyint", { name: "pending", width: 1 })
  pending: boolean;

  @Column("int", { name: "relationId", nullable: true })
  relationId: number | null;

  @Column("int", { name: "userId" })
  userId: number;

  @Column("int", { name: "groupId" })
  groupId: number;

  @ManyToOne(
    () => Group,
    group => group.operations,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => Operation,
    operation => operation.operations,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "relationId", referencedColumnName: "id" }])
  relation: Operation;

  @OneToMany(
    () => Operation,
    operation => operation.relation
  )
  operations: Operation[];

  @ManyToOne(
    () => User,
    user => user.operations,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
