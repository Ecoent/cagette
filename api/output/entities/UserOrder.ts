import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Basket } from "./Basket";
import { Distribution } from "./Distribution";
import { Product } from "./Product";
import { User } from "./User";

@Index("UserContract_productId", ["productId"], {})
@Index("UserContract_userId2", ["userId2"], {})
@Index("UserContract_userId", ["userId"], {})
@Index("UserContract_distributionId", ["distributionId"], {})
@Index("UserContract_basketId", ["basketId"], {})
@Entity("UserOrder", { schema: "db" })
export class UserOrder {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("double", { name: "quantity", precision: 22 })
  quantity: number;

  @Column("int", { name: "userId" })
  userId: number;

  @Column("int", { name: "userId2", nullable: true })
  userId2: number | null;

  @Column("int", { name: "productId" })
  productId: number;

  @Column("tinyint", { name: "paid", width: 1 })
  paid: boolean;

  @Column("int", { name: "distributionId", nullable: true })
  distributionId: number | null;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("double", { name: "feesRate", precision: 22 })
  feesRate: number;

  @Column("double", { name: "productPrice", precision: 22 })
  productPrice: number;

  @Column("int", { name: "flags" })
  flags: number;

  @Column("int", { name: "basketId", nullable: true })
  basketId: number | null;

  @ManyToOne(
    () => Basket,
    basket => basket.userOrders,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "basketId", referencedColumnName: "id" }])
  basket: Basket;

  @ManyToOne(
    () => Distribution,
    distribution => distribution.userOrders,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "distributionId", referencedColumnName: "id" }])
  distribution: Distribution;

  @ManyToOne(
    () => Product,
    product => product.userOrders,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "productId", referencedColumnName: "id" }])
  product: Product;

  @ManyToOne(
    () => User,
    user => user.userOrders,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;

  @ManyToOne(
    () => User,
    user => user.userOrders2,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId2", referencedColumnName: "id" }])
  userId3: User;
}
