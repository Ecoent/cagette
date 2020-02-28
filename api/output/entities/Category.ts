import {
  Column,
  Entity,
  Index,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { CategoryGroup } from "./CategoryGroup";
import { Product } from "./Product";

@Index("Category_categoryGroupId", ["categoryGroupId"], {})
@Entity("Category", { schema: "db" })
export class Category {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("int", { name: "categoryGroupId" })
  categoryGroupId: number;

  @ManyToOne(
    () => CategoryGroup,
    categoryGroup => categoryGroup.categories,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "categoryGroupId", referencedColumnName: "id" }])
  categoryGroup: CategoryGroup;

  @ManyToMany(
    () => Product,
    product => product.categories
  )
  @JoinTable({
    name: "ProductCategory",
    joinColumns: [{ name: "categoryId", referencedColumnName: "id" }],
    inverseJoinColumns: [{ name: "productId", referencedColumnName: "id" }],
    schema: "db"
  })
  products: Product[];
}
