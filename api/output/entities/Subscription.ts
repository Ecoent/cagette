import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Catalog } from "./Catalog";
import { User } from "./User";

@Index("Subscription_catalogId", ["catalogId"], {})
@Index("Subscription_userId", ["userId"], {})
@Entity("Subscription", { schema: "db" })
export class Subscription {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("date", { name: "startDate" })
  startDate: string;

  @Column("date", { name: "endDate" })
  endDate: string;

  @Column("tinyint", { name: "isValidated", width: 1 })
  isValidated: boolean;

  @Column("int", { name: "userId" })
  userId: number;

  @Column("int", { name: "catalogId" })
  catalogId: number;

  @Column("tinyint", { name: "isPaid", width: 1 })
  isPaid: boolean;

  @ManyToOne(
    () => Catalog,
    catalog => catalog.subscriptions,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "catalogId", referencedColumnName: "id" }])
  catalog: Catalog;

  @ManyToOne(
    () => User,
    user => user.subscriptions,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
