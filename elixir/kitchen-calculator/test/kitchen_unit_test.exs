defmodule KitchenUnitTest do
  use ExUnit.Case

  test "cup" do
    assert KitchenUnit.to_milliliter({:cup, 1}) ==
             {:ok, %KitchenUnit{name: :milliliter, volume: 240}}

    assert KitchenUnit.to_milliliter({:cup, 2}) ==
             {:ok, %KitchenUnit{name: :milliliter, volume: 480}}

    assert KitchenUnit.to_milliliter({:cup, 3}) ==
             {:ok, %KitchenUnit{name: :milliliter, volume: 720}}
  end

  test "conversion" do
    assert KitchenUnit.from_unit_to({:cup, 1}, :fluid_ounce) ==
             {:ok, %KitchenUnit{name: :fluid_ounce, volume: 8}}

    assert KitchenUnit.from_unit_to({:fluid_ounce, 1}, :tablespoon) ==
             {:ok, %KitchenUnit{name: :tablespoon, volume: 2}}

    assert KitchenUnit.from_unit_to({:pinter, 1}, :tablespoon) ==
             {:error, :unknown_unit}
  end

  test "unknown" do
    assert KitchenUnit.to_milliliter({:pinter, 1}) == {:error, :unknown_unit}
    assert KitchenUnit.to_milliliter("bogus") == {:error, :unknown_unit}
  end
end
