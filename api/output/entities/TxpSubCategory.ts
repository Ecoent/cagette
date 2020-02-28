import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { TxpProduct } from "./TxpProduct";
import { TxpCategory } from "./TxpCategory";

@Index("TxpSubCategory_categoryId", ["categoryId"], {})
@Entity("TxpSubCategory", { schema: "db" })
export class TxpSubCategory {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("int", { name: "categoryId" })
  categoryId: number;

  @OneToMany(
    () => TxpProduct,
    txpProduct => txpProduct.subCategory
  )
  txpProducts: TxpProduct[];

  @ManyToOne(
    () => TxpCategory,
    txpCategory => txpCategory.txpSubCategories,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "categoryId", referencedColumnName: "id" }])
  category: TxpCategory;
}
