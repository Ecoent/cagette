import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { PProduct } from "./PProduct";
import { Product } from "./Product";
import { TxpCategory } from "./TxpCategory";
import { TxpSubCategory } from "./TxpSubCategory";

@Index("TxpProduct_subCategoryId", ["subCategoryId"], {})
@Index("TxpProduct_categoryId", ["categoryId"], {})
@Entity("TxpProduct", { schema: "db" })
export class TxpProduct {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("int", { name: "categoryId" })
  categoryId: number;

  @Column("int", { name: "subCategoryId" })
  subCategoryId: number;

  @OneToMany(
    () => PProduct,
    pProduct => pProduct.txpProduct
  )
  pProducts: PProduct[];

  @OneToMany(
    () => Product,
    product => product.txpProduct
  )
  products: Product[];

  @ManyToOne(
    () => TxpCategory,
    txpCategory => txpCategory.txpProducts,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "categoryId", referencedColumnName: "id" }])
  category: TxpCategory;

  @ManyToOne(
    () => TxpSubCategory,
    txpSubCategory => txpSubCategory.txpProducts,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "subCategoryId", referencedColumnName: "id" }])
  subCategory: TxpSubCategory;
}
