import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToMany,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Catalog } from "./Catalog";
import { File } from "./File";
import { TxpProduct } from "./TxpProduct";
import { Category } from "./Category";
import { UserOrder } from "./UserOrder";

@Index("Product_contractId", ["catalogId"], {})
@Index("Product_imageId", ["imageId"], {})
@Index("Product_txpProductId", ["txpProductId"], {})
@Entity("Product", { schema: "db" })
export class Product {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("int", { name: "catalogId" })
  catalogId: number;

  @Column("double", { name: "price", precision: 22 })
  price: number;

  @Column("mediumtext", { name: "desc", nullable: true })
  desc: string | null;

  @Column("double", { name: "vat", precision: 22 })
  vat: number;

  @Column("varchar", { name: "ref", nullable: true, length: 32 })
  ref: string | null;

  @Column("int", { name: "imageId", nullable: true })
  imageId: number | null;

  @Column("double", { name: "stock", nullable: true, precision: 22 })
  stock: number | null;

  @Column("tinyint", { name: "hasFloatQt", width: 1 })
  hasFloatQt: boolean;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("double", { name: "qt", nullable: true, precision: 22 })
  qt: number | null;

  @Column("tinyint", { name: "unitType", nullable: true, unsigned: true })
  unitType: number | null;

  @Column("int", { name: "txpProductId", nullable: true })
  txpProductId: number | null;

  @Column("tinyint", { name: "organic", width: 1 })
  organic: boolean;

  @Column("tinyint", { name: "variablePrice", width: 1 })
  variablePrice: boolean;

  @Column("tinyint", { name: "multiWeight", width: 1 })
  multiWeight: boolean;

  @Column("tinyint", { name: "bulk", width: 1 })
  bulk: boolean;

  @Column("tinyint", { name: "wholesale", width: 1 })
  wholesale: boolean;

  @Column("tinyint", { name: "retail", width: 1 })
  retail: boolean;

  @ManyToOne(
    () => Catalog,
    catalog => catalog.products,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "catalogId", referencedColumnName: "id" }])
  catalog: Catalog;

  @ManyToOne(
    () => File,
    file => file.products,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "imageId", referencedColumnName: "id" }])
  image: File;

  @ManyToOne(
    () => TxpProduct,
    txpProduct => txpProduct.products,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "txpProductId", referencedColumnName: "id" }])
  txpProduct: TxpProduct;

  @ManyToMany(
    () => Category,
    category => category.products
  )
  categories: Category[];

  @OneToMany(
    () => UserOrder,
    userOrder => userOrder.product
  )
  userOrders: UserOrder[];
}
