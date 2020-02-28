import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { MultiDistrib } from "./MultiDistrib";
import { User } from "./User";
import { UserOrder } from "./UserOrder";

@Index("Basket_userId", ["userId"], {})
@Index("Basket_ref", ["ref"], {})
@Index("Basket_multiDistribId", ["multiDistribId"], {})
@Entity("Basket", { schema: "db" })
export class Basket {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("datetime", { name: "cdate" })
  cdate: Date;

  @Column("int", { name: "num" })
  num: number;

  @Column("mediumblob", { name: "data", nullable: true })
  data: Buffer | null;

  @Column("varchar", { name: "ref", nullable: true, length: 256 })
  ref: string | null;

  @Column("int", { name: "multiDistribId" })
  multiDistribId: number;

  @Column("int", { name: "userId" })
  userId: number;

  @ManyToOne(
    () => MultiDistrib,
    multiDistrib => multiDistrib.baskets,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "multiDistribId", referencedColumnName: "id" }])
  multiDistrib: MultiDistrib;

  @ManyToOne(
    () => User,
    user => user.baskets,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;

  @OneToMany(
    () => UserOrder,
    userOrder => userOrder.basket
  )
  userOrders: UserOrder[];
}
