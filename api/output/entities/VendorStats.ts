import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Vendor } from "./Vendor";

@Index("VendorStats_vendorId", ["vendorId"], {})
@Entity("VendorStats", { schema: "db" })
export class VendorStats {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("tinyint", { name: "type", unsigned: true })
  type: number;

  @Column("tinyint", { name: "active", width: 1 })
  active: boolean;

  @Column("int", { name: "vendorId", nullable: true })
  vendorId: number | null;

  @ManyToOne(
    () => Vendor,
    vendor => vendor.vendorStats,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "vendorId", referencedColumnName: "id" }])
  vendor: Vendor;
}
