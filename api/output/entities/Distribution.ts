import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Catalog } from "./Catalog";
import { MultiDistrib } from "./MultiDistrib";
import { Place } from "./Place";
import { UserOrder } from "./UserOrder";

@Index("Distribution_contractId", ["catalogId"], {})
@Index("Distribution_placeId", ["placeId"], {})
@Index("Distribution_multiDistribId", ["multiDistribId"], {})
@Entity("Distribution", { schema: "db" })
export class Distribution {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("datetime", { name: "date", nullable: true })
  date: Date | null;

  @Column("int", { name: "catalogId" })
  catalogId: number;

  @Column("int", { name: "placeId" })
  placeId: number;

  @Column("datetime", { name: "end", nullable: true })
  end: Date | null;

  @Column("datetime", { name: "orderStartDate", nullable: true })
  orderStartDate: Date | null;

  @Column("datetime", { name: "orderEndDate", nullable: true })
  orderEndDate: Date | null;

  @Column("int", { name: "multiDistribId" })
  multiDistribId: number;

  @ManyToOne(
    () => Catalog,
    catalog => catalog.distributions,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "catalogId", referencedColumnName: "id" }])
  catalog: Catalog;

  @ManyToOne(
    () => MultiDistrib,
    multiDistrib => multiDistrib.distributions,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "multiDistribId", referencedColumnName: "id" }])
  multiDistrib: MultiDistrib;

  @ManyToOne(
    () => Place,
    place => place.distributions,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "placeId", referencedColumnName: "id" }])
  place: Place;

  @OneToMany(
    () => UserOrder,
    userOrder => userOrder.distribution
  )
  userOrders: UserOrder[];
}
