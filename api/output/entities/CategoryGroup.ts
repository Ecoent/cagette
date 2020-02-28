import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Category } from "./Category";
import { Group } from "./Group";

@Index("CategoryGroup_amapId", ["amapId"], {})
@Entity("CategoryGroup", { schema: "db" })
export class CategoryGroup {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("tinyint", { name: "color" })
  color: number;

  @Column("int", { name: "amapId" })
  amapId: number;

  @Column("tinyint", { name: "pinned", width: 1 })
  pinned: boolean;

  @OneToMany(
    () => Category,
    category => category.categoryGroup
  )
  categories: Category[];

  @ManyToOne(
    () => Group,
    group => group.categoryGroups,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "amapId", referencedColumnName: "id" }])
  amap: Group;
}
